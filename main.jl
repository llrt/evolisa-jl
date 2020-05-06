using Images, FileIO
using ImageView

include("settings.jl")
include("dna.jl")
include("renderer.jl")
include("fitness.jl")


orig_img_path = "./monalisa.jpg" # ARGS[1]
orig_img = load(orig_img_path)


(MAX_WIDTH, MAX_HEIGHT) = size(orig_img)


current_pic = Pic()

generation = 0
selected = 0
error_level = Inf

while true
    global orig_img
    global MAX_WIDTH
    global MAX_HEIGHT
    
    global current_pic
    
    global generation
    global selected
    global error_level

    new_pic = deepcopy(current_pic)
    mutate!(new_pic)

    if new_pic.dirty
        generation += 1

        img = render(new_pic, 1, MAX_WIDTH, MAX_HEIGHT, generation)
        new_error_level = fitness(img, orig_img)

        if new_error_level <= error_level
            selected += 1

            current_pic = new_pic
            error_level = new_error_level

            if selected % 100 == 0
                @info "generation = $generation"
                @info "selected = $selected"
                @info "error_level = $error_level"        
            end
        end
    end
end