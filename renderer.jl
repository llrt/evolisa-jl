using Luxor
using Dates

function render(pic::Pic, scale::Int64, max_width::Int64=500, max_height::Int64=500, generation::Int64=0)
    fname = "evolisa.png"
    
    Drawing(max_width, max_height, fname)
    background("black")
    sethue("black")
    
    begin
        for i in 1:length(pic.polygons)
            @layer render(pic.polygons[i], scale)
        end    
        
    end

    finish()

    img = load(fname)
    img
end

function render(pol::Polygon, scale::Int64)
    pts = pol.pts
    scaled_points = map((p::Pt) -> Point(round(Int, p.x*scale), round(Int, p.y*scale)), pts)

    brush = pol.brush
    (red, green, blue, alpha) = (brush.r/255, brush.g/255, brush.b/255, brush.alpha/100)
    setcolor(red, green, blue, alpha)

    poly(scaled_points, :fill, close=true)   
end