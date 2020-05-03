using Luxor

include("settings.jl")

function render(pic::Pic, scale::Int64)
    @png begin
        for i in 1:length(pic.polygons)
            @layer render(pic.polygons[i], scale)
        end    
    end 500 500

end

function render(pol::Polygon, scale::Int64)
    pts = pol.pts
    scaled_points = map((p::Pt) -> Point(round(Int, p.x*scale), round(Int, p.y*scale)), pts)

    brush = pol.brush
    (red, green, blue, alpha) = (brush.r/255, brush.g/255, brush.b/255, brush.alpha/100)
    setcolor(red, green, blue, alpha)

    @info scaled_points
    poly(scaled_points, :fill, close=true)   
end