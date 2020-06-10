import Base.:(==)

function configure_joblib()

end

function configure_logging() 

end

function configure_precision() 

end

mutable struct Option{T}
    current::T
    default::T
    name::Union{Nothing, String}
    values::Union{Nothing, Array{T, 1}}
    on_change::Union{Nothing, Function}
    doc::Union{Nothing, String}
    
    function Option{T}(
        default; name=nothing, values=nothing, on_change=nothing, doc=nothing
    ) where T 
        new(
            default,
            default,
            name,
            values,
            on_change,
            doc
        )
    end
end

struct Configuration
    options::Dict{Symbol, Option}

    function Configuration() 
        options = Dict()

        options[:ASSUME_CUTS_CANNOT_CREATE_NEW_CONCEPTS] = Option{Bool}(false)

        options[:CUT_ONE_APPROXIMATION] = Option{Bool}(false)

        options[:MEASURE] = Option{String}("EMD")

        options[:ACTUAL_CAUSATION_MEASURE] = Option{String}("PMI")

        options[:PARALLEL_CONCEPT_EVALUATION] = Option{Bool}(false)

        options[:PARALLEL_CUT_EVALUATION] = Option{Bool}(true)

        options[:PARALLEL_COMPLEX_EVALUATION] = Option{Bool}(false)

        options[:NUMBER_OF_CORES] = Option{Integer}(-1)

        options[:MAXIMUM_CACHE_MEMORY_PERCENTAGE] = Option{Integer}(50)

        options[:CACHE_SIAS] = Option{Bool}(false)

        options[:CACHE_REPERTOIRES] = Option{Bool}(true)

        options[:CACHE_POTENTIAL_PURVIEWS] = Option{Bool}(true)

        options[:CLEAR_SUBSYSTEM_CACHES_AFTER_COMPUTING_SIA] = Option{Bool}(false)

        options[:CACHING_BACKEND] = Option{String}("fs")

        options[:FS_CACHE_VERBOSITY] = Option{Integer}(0;
            on_change=configure_joblib
        )

        options[:FS_CACHE_DIRECTORY] = Option{String}("__pyphi_cache__";
            on_change=configure_joblib
        )

        options[:MONGODB_CONFIG] = Option{Dict}(Dict(
            "host"=>"localhost",
            "port"=>27017,
            "database_name"=>"pyphi",
            "collection_name"=>"cache",
        ))

        options[:REDIS_CACHE] = Option{Bool}(false)

        options[:REDIS_CONFIG] = Option{Dict}(Dict(
            "host"=>"localhost", 
            "port"=>6379, 
            "db"=>0, 
            "test_db"=>1
        ))

        options[:WELCOME_OFF] = Option{Bool}(false)
        
        options[:LOG_FILE] = Option{String}("pyphi.log";
            on_change=configure_logging
        )
        
        options[:LOG_FILE_LEVEL] = Option{String}("INFO";
            on_change=configure_logging
        )

        options[:LOG_STDOUT_LEVEL] = Option{String}("WARNING";
            on_change=configure_logging
        )

        options[:PROGRESS_BARS] = Option{Bool}(true)
        
        options[:PRECISION] = Option{Integer}(6;
            on_change=configure_precision
        )
        
        options[:VALIDATE_SUBSYSTEM_STATES] = Option{Bool}(true)
        
        options[:VALIDATE_CONDITIONAL_INDEPENDENCE] = Option{Bool}(true)
        
        options[:SINGLE_MICRO_NODES_WITH_SELFLOOPS_HAVE_PHI] = Option{Bool}(false)
        
        options[:REPR_VERBOSITY] = Option{Integer}(2;
            values=[0, 1, 2]
        )

        options[:PRINT_FRACTIONS] = Option{Bool}(true)

        options[:PARTITION_TYPE] = Option{String}("BI")

        options[:PICK_SMALLEST_PURVIEW] = Option{Bool}(false)

        options[:USE_SMALL_PHI_DIFFERENCE_FOR_CES_DISTANCE] = Option{Bool}(false)

        options[:SYSTEM_CUTS] = Option{String}("3.0_STYLE";
            values=["3.0_STYLE", "CONCEPT_STYLE"]
        )

        new(options)
    end
end


const configuration = Configuration()


function Base.getproperty(config::Configuration, sym::Symbol)
    if hasproperty(config, sym)
        return getfield(config, sym)
    elseif haskey(getfield(config, :options), sym)
        return getfield(config, :options)[sym].current
    else
        error("Invalid configuration option")
    end
end


function Base.setproperty!(config::Configuration, sym::Symbol, x)
    if haskey(getfield(config, :options), sym)
        option = getfield(config, :options)[sym]
        validate_set_config(option, x)
        option.current = x
        if option.on_change !== nothing
            option.on_change(sym, x)
        end
    else
        error("Invalid configuration option")
    end
end

function validate_set_config(option::Option, x)
    if option.values !== nothing && x ∉ option.values
        error("$x is not a valid value")
    end
end