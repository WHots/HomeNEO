using JSON




"""
    @is_date_in_range(date_str, start_year, end_year)

Determines if the year extracted from a date string falls within a specified range of years.

# Arguments
- `date_str`: A string representing a date, expected to be in the format "YYYY-MM-DD".
- `start_year`: An integer specifying the start of the year range.
- `end_year`: An integer specifying the end of the year range.

# Returns
- `Bool`: `true` if the year is within the range, `false` otherwise.
"""
@inline function is_date_in_range(date_str, start_year::Int, end_year::Int)
    year = parse(Int, split(date_str, "-")[1]) 
    return year in start_year:end_year 
end


"""
    @generic_parse(response_json)

Parses a JSON object containing near-Earth object data, filtering for Earth-orbiting objects within a specified date range, and transforms the data into a JSON string.

# Arguments
- `response_json`: A JSON object containing an array of close approach data.

# Returns
- `String`: A JSON string representing the transformed data.
"""
function generic_parse(response_json)

    earth_approach_data = filter(close_approach -> close_approach["orbiting_body"] == "Earth" && is_date_in_range(close_approach["close_approach_date_full"], 2000, 2024), response_json["close_approach_data"])
    transformed_data = map(close_approach -> Dict(
        "Date" => close_approach["close_approach_date_full"],
        "Lunar Distance" => close_approach["miss_distance"]["lunar"],
        "Velocity" => close_approach["relative_velocity"]["miles_per_hour"]),
        earth_approach_data
        )

    earth_approach_data_json = JSON.json(transformed_data)

    return earth_approach_data_json
end