using HTTP
using Dates
using Plots
using Printf

include("parseutils.jl")
include("mathutils.jl")



@inline macro valid_response(response)
    return :($(esc(response)).status == 200)
end

# Register for NASA public API here.
# https://api.nasa.gov
const BASE_URL = "https://api.nasa.gov/neo/rest/v1/neo/"
ENDPOINT = "ASTROID ID"
API_KEY = "YOUR API KEY"


function fetch_data()

    url = BASE_URL * ENDPOINT * "?api_key=" * API_KEY

    response = HTTP.get(url)

    if @valid_response(response)
        json_data = String(response.body)
        api_resp = JSON.parse(json_data)
        return generic_parse(api_resp)
    else
        println("Something went wrong :( HTTP Error Code: $(response.status)")
        return nothing
    end
end


function process_data(data)

    plot_dates = String[]
    lunar_distances = Float64[]

    @inbounds for data_point in data
        date = data_point["Date"]
        lunar_distance_str = data_point["Lunar Distance"]
        velocity = parse(Float64, data_point["Velocity"])

        shortened_date = split(date, " ")[1][1:8]   # yyyy-month

        push!(plot_dates, shortened_date)
        lunar_distance = parse(Float64, lunar_distance_str)
        push!(lunar_distances, lunar_distance)

        velocity_kph = @mph2kph(velocity)
        velocity_mach = @mach_from_mph(velocity)

        @printf("Date: %s | Lunar Distance: %.2f | Velocity: %.2f Mp/h (%.2f Kp/h, Mach %.2f)\n", date, lunar_distance, velocity, velocity_kph, velocity_mach)
    end

    return plot_dates, lunar_distances
end


function plot_data(plot_dates, lunar_distances)

    sorted_indices = sortperm(lunar_distances)
    sorted_plot_dates = plot_dates[sorted_indices]
    sorted_lunar_distances = lunar_distances[sorted_indices]
    sorted_plot_dates = reverse(sorted_plot_dates)
    sorted_lunar_distances = reverse(sorted_lunar_distances)

    scatter(sorted_plot_dates, sorted_lunar_distances, xlabel="Date", ylabel="Lunar Distance", size=(1200, 800))
end


function main()

    data = fetch_data()
    isnothing(data) && return

    parsed_data = JSON.parse(data)

    plot_dates, lunar_distances = process_data(parsed_data)
    plot_data(plot_dates, lunar_distances)
end


main()