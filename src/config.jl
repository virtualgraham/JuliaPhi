function configure_joblib()

end

function configure_logging() 

end

function configure_precision() 

end

mutable struct Option
    current
    default
    name
    values
    on_change
    doc
    
    function Option(
        default; name=nothing, values=nothing, on_change=nothing, doc=nothing
    )
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

        options[:ASSUME_CUTS_CANNOT_CREATE_NEW_CONCEPTS] = Option(false)

        options[:CUT_ONE_APPROXIMATION] = Option(false)

        options[:MEASURE] = Option("EMD")

        options[:ACTUAL_CAUSATION_MEASURE] = Option("PMI")

        options[:PARALLEL_CONCEPT_EVALUATION] = Option(false)

        options[:PARALLEL_CUT_EVALUATION] = Option(true)

        options[:PARALLEL_COMPLEX_EVALUATION] = Option(false)

        options[:NUMBER_OF_CORES] = Option(-1)

        options[:MAXIMUM_CACHE_MEMORY_PERCENTAGE] = Option(50)

        options[:CACHE_SIAS] = Option(false)

        options[:CACHE_REPERTOIRES] = Option(true)

        options[:CACHE_POTENTIAL_PURVIEWS] = Option(true)

        options[:CLEAR_SUBSYSTEM_CACHES_AFTER_COMPUTING_SIA] = Option(false)

        options[:CACHING_BACKEND] = Option("fs")

        options[:FS_CACHE_VERBOSITY] = Option(0;
            on_change=configure_joblib
        )

        options[:FS_CACHE_DIRECTORY] = Option("__pyphi_cache__";
            on_change=configure_joblib
        )

        options[:MONGODB_CONFIG] = Option(Dict(
            "host"=>"localhost",
            "port"=>27017,
            "database_name"=>"pyphi",
            "collection_name"=>"cache",
        ))

        options[:REDIS_CACHE] = Option(false)

        options[:REDIS_CONFIG] = Option(Dict(
            "host"=>"localhost", 
            "port"=>6379, 
            "db"=>0, 
            "test_db"=>1
        ))

        options[:WELCOME_OFF] = Option(false)
        
        options[:LOG_FILE] = Option("pyphi.log";
            on_change=configure_logging
        )
        
        options[:LOG_FILE_LEVEL] = Option("INFO";
            on_change=configure_logging
        )

        options[:LOG_STDOUT_LEVEL] = Option("WARNING";
            on_change=configure_logging
        )

        options[:PROGRESS_BARS] = Option(true)
        
        options[:PRECISION] = Option(6;
            on_change=configure_precision
        )
        
        options[:VALIDATE_SUBSYSTEM_STATES] = Option(true)
        
        options[:VALIDATE_CONDITIONAL_INDEPENDENCE] = Option(true)
        
        options[:SINGLE_MICRO_NODES_WITH_SELFLOOPS_HAVE_PHI] = Option(false)
        
        options[:REPR_VERBOSITY] = Option(2;
            values=[0, 1, 2]
        )

        options[:PRINT_FRACTIONS] = Option(true)

        options[:PARTITION_TYPE] = Option("BI")

        options[:PICK_SMALLEST_PURVIEW] = Option(false)

        options[:USE_SMALL_PHI_DIFFERENCE_FOR_CES_DISTANCE] = Option(false)

        options[:SYSTEM_CUTS] = Option("3.0_STYLE";
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
        # TODO validate
        getfield(config, :options)[sym].current = x
        # TODO call on_change
    else
        error("Invalid configuration option")
    end
end