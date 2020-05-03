include("settings.jl")

# util function for determining whether mutation occurs
function willmutate(mutrate::Int64)
    rand(1:mutrate) == 1
end


# Pt = Point original type
struct Pt
    x::Int64
    y::Int64
end
# 0-args constructor
Pt() = Pt(rand(1:MAX_WIDTH), rand(1:MAX_HEIGHT))

# Brush
struct Brush
    r::UInt8
    g::UInt8
    b::UInt8
    alpha::UInt8
end
# 0-args constructor
Brush() = Brush(rand(RED_RANGE_MIN:RED_RANGE_MAX), 
                rand(GREEN_RANGE_MIN:GREEN_RANGE_MAX), 
                rand(BLUE_RANGE_MIN:BLUE_RANGE_MAX), 
                rand(ALPHA_RANGE_MIN:ALPHA_RANGE_MAX))


# Polygon
mutable struct Polygon
    pts::Array{Pt, 1}
    brush::Brush
end
# 0-args, complex constructor
function Polygon()
    pts = Pt[]

    origin = Pt()
    for i in 1:POINTS_PER_POLYGON_MIN
        x = min(max(0, origin.x + rand(-10:10)), MAX_WIDTH)
        y = min(max(0, origin.y + rand(-10:10)), MAX_HEIGHT)
        pt = Pt(x, y)
        push!(pts, pt)
    end

    Polygon(pts, Brush())
end

# Pic = original Drawing type
mutable struct Pic
    polygons::Array{Polygon, 1}
    dirty::Bool
end
# 0-args, complex constructor
function Pic()
    polygons = Polygon[]

    for i in 1:POLYGONS_MIN
        push!(polygons, Polygon())
    end

    Pic(polygons, false)
end


function addpolygon!(pic::Pic)
    if length(pic.polygons) < POLYGONS_MAX
        poly = Polygon()
        i = rand(1:length(pic.polygons))

        insert!(pic.polygons, i, poly)
        
        pic.dirty = true
    end
end
function rmpolygon!(pic::Pic)
    if length(pic.polygons) > POLYGONS_MIN
        i = rand(1:length(pic.polygons))

        splice!(pic.polygons, i)
        
        pic.dirty = true
    end
end
function mvpolygon!(pic::Pic)
    if length(pic.polygons) >= 1
        i = rand(1:length(pic.polygons))
        poly = deepcopy(pic.polygons[i])
        splice!(pic.polygons, i)

        j = rand(1:length(pic.polygons))
        insert!(pic.polygons, j, poly)

        pic.dirty = true
    end
end
function addpoint!(pic::Pic, poly::Polygon)
    pic_pt_count = mapreduce(poly::Polygon->length(poly.pts), +, pic.polygons)

    if length(poly.pts) < POINTS_PER_POLYGON_MAX
        if pic_pt_count < POINTS_MAX
            i = rand(2:length(poly.pts))

            p_prev = poly.pts[i-1]
            p_next = poly.pts[i]

            
            x = round(Int, (p_prev.x + p_next.x)/2)
            y = round(Int, (p_prev.y + p_next.y)/2)

            p = Pt(x, y)

            insert!(poly.pts, i, p)
            
            pic.dirty = true
        end
    end
end
function rmpoint!(pic::Pic, poly::Polygon)
    pic_pt_count = mapreduce(poly::Polygon->length(poly.pts), +, pic.polygons)

    if length(poly.pts) > POINTS_PER_POLYGON_MIN
        if pic_pt_count > POINTS_MIN
            i = rand(1:length(poly.pts))
            splice!(poly.pts, i)
            
            pic.dirty = true
        end
    end
end



function mutate!(pic::Pic)
    if willmutate(ADD_POLYGON_MUTATION_RATE)
        addpolygon!(pic)
    end
    if willmutate(REMOVE_POLYGON_MUTATION_RATE)
        rmpolygon!(pic)
    end
    if willmutate(MOVE_POLYGON_MUTATION_RATE)
        mvpolygon!(pic)
    end

    for poly in pic.polygons
        mutate!(pic, poly)
    end
end

function mutate!(pic::Pic, poly::Polygon)
    if willmutate(ADD_POINT_MUTATION_RATE)
        addpoint!(pic, poly)
    end
    if willmutate(ADD_POINT_MUTATION_RATE)
        rmpoint!(pic, poly)
    end

    poly.brush = mutate(pic, poly.brush)

    map!((p::Pt) -> mutate(pic, p), poly.pts, poly.pts)
end

function mutate(pic::Pic, p::Pt)
    x = p.x
    y = p.y

    if willmutate(MOVE_POINT_MAX_MUTATION_RATE)
        x = rand(1:MAX_WIDTH)
        y = rand(1:MAX_HEIGHT)

        pic.dirty = true
    end

    if willmutate(MOVE_POINT_MID_MUTATION_RATE)
        x = min(max(0, 
                      x + rand(-MOVE_POINT_RANGE_MID:MOVE_POINT_RANGE_MID)), 
                  MAX_WIDTH)
        y = min(max(0, 
                      y + rand(-MOVE_POINT_RANGE_MID:MOVE_POINT_RANGE_MID)), 
                  MAX_HEIGHT)

        pic.dirty = true
    end

    if willmutate(MOVE_POINT_MIN_MUTATION_RATE)
        x = min(max(0, 
                      x + rand(-MOVE_POINT_RANGE_MIN:MOVE_POINT_RANGE_MIN)), 
                  MAX_WIDTH)
        y = min(max(0, 
                      y + rand(-MOVE_POINT_RANGE_MIN:MOVE_POINT_RANGE_MIN)), 
                  MAX_HEIGHT)
        
        pic.dirty = true
    end

    Pt(x, y)
end

function mutate(pic::Pic, brush::Brush)
    (red, green, blue, alpha) =  (brush.r, brush.g, brush.b, brush.alpha)

    if willmutate(RED_MUTATION_RATE)
        red = rand(RED_RANGE_MIN:RED_RANGE_MAX)

        pic.dirty = true
    end

    if willmutate(GREEN_MUTATION_RATE)
        green = rand(GREEN_RANGE_MIN:GREEN_RANGE_MAX)

        pic.dirty = true
    end

    if willmutate(BLUE_MUTATION_RATE)
        blue = rand(BLUE_RANGE_MIN:BLUE_RANGE_MAX)

        pic.dirty = true
    end

    if willmutate(ALPHA_MUTATION_RATE)
        alpha = rand(ALPHA_RANGE_MIN:ALPHA_RANGE_MAX)

        pic.dirty = true
    end

    Brush(red, green, blue, alpha)
end