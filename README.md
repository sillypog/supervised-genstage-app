# Supervised GenStage App

An example of a supervised Elixir GenStage application.

This is the example application I presented at the Erlang & Elixir SF meetup at Pinterest on 2/22/17. Slides are at [http://sillypog.com/elixir-meetup-0217-genstage](http://sillypog.com/elixir-meetup-0217-genstage).

I have broken the application down into various steps. Comments within the code at each step indicate what has changed and why, and include prompts to make further modifications within that step to explore GenStage behaviour. Each step is a separate git branch.

## example-step-1
Setup of a GenStage application almost exactly as defined in the module documentation at https://hexdocs.pm/gen_stage/GenStage.html. The pipeline has these stages:
- Example.A: producer
- Example.B: producer/consumer
- Exmaple.C: consumer

With the settings defined here, output will be:
```
  Application started
  Initalised Producer A with counter at 0
  Initalised Producer/Consumer B with multiplier 2
  Initialized Consumer C
  Producer A handling demand of 1 with 0
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 1
  Consumer C handling events
  [0]
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 2
  Consumer C handling events
  [2]
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 3
  Consumer C handling events
  [4]
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 4
  Consumer C handling events
  [6]
```

With Example.B max_demand: 1, Example.C max_demand: 2 it becomes:
```
  Application started
  Initalised Producer A with counter at 0
  Initalised Producer/Consumer B with multiplier 2
  Initialized Consumer C
  Producer A handling demand of 1 with 0
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 1
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 2
  Consumer C handling events
  [0]
  Consumer C handling events
  [2]
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 3
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 4
  Consumer C handling events
  [4]
  Consumer C handling events
  [6]
```

With Example.B max_demand: 2, Example.C max_demand: 2 it becomes:
```
  Application started
  Initalised Producer A with counter at 0
  Initalised Producer/Consumer B with multiplier 2
  Initialized Consumer C
  Producer A handling demand of 2 with 0
  Producer/Consumer B incrementing 2 events
  Producer A handling demand of 2 with 2
  Consumer C handling events
  [0, 2]
  Producer/Consumer B incrementing 2 events
  Producer A handling demand of 2 with 4
  Consumer C handling events
  [4, 6]
```

## example-step-2-subscribing
By using named processes, each stage automatically subscribes to the upstream stage.

With the application running via `iex -S mix`, :observer.start can be used to view the process graph. Killing the Example.B process also kills the Example.C process and data consumption halts.

## example-step-3-supervision
The stages are now launched under a supervision tree. Killing Example.B still kills Example.C, but now both are relaunched and data consumption continues, with the unnamed Example.C process displaying its new PID.

## example-step-4-supervisor-arguments
As a first step to making the pipeline configurable, arguments are passed to the individual stages from the application, via the supervisor. At this point is not possible to launch multiple pipelines reading from the same consumer, because the process name "Example.B" has already been taken.
```
  ** (Mix) Could not start application palleto: Palleto.start(:normal, []) returned an error: shutdown: failed to start child: 2
      ** (EXIT) shutdown: failed to start child: Example.B
          ** (EXIT) already started: #PID<0.153.0>
```

## example-step-5-multiple-pipelines
By passing the pipeline name into each pipeline, a unique name can be created for the stages in each pipeline, and they are still discoverable by their subscriber. It is now possible to have pipelines that process the data at different rates.

## example-step-6-configurable-demand
Demand for each pipeline is now set independently. Adjust this to see the change in output. A warning is generated if the demand in the second pipeline is higher than the first; this warning does not occur id the order of the pipelines is switched.
```
  Initalised Producer A with counter at 0
  Example.Supervisor FastPipeline 1000
  Start Example.B as FastPipelineB
  Initalised Producer/Consumer B with multiplier 2
  Producer A handling demand of 1 with 0
  Start Example.B as FastPipelineC
  Subscribing Consumer C to FastPipelineB
  Example.Supervisor SlowPipeline 5000
  Start Example.B as SlowPipelineB
  Initalised Producer/Consumer B with multiplier 2
  Start Example.B as SlowPipelineC
  Subscribing Consumer C to SlowPipelineB
  Producer A handling demand of 3 with 1
  Producer/Consumer B incrementing 1 events
  Producer/Consumer B incrementing 3 events
  Producer A handling demand of 1 with 4
  Producer A handling demand of 3 with 5
  Interactive Elixir (1.3.2) - press Ctrl+C to exit (type h() ENTER for help)
  iex(1)>
  12:01:57.604 [warn]  GenStage producer DemandDispatcher expects a maximum demand of 1. Using different maximum demands will overload greedy consumers. Got demand for 3 events from #PID<0.148.0>


  12:01:57.604 [warn]  GenStage producer DemandDispatcher expects a maximum demand of 1. Using different maximum demands will overload greedy consumers. Got demand for 3 events from #PID<0.148.0>

  FastPipeline: 0
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 8
  FastPipeline: 8
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 9
  FastPipeline: 16
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 10
  FastPipeline: 18
  Producer/Consumer B incrementing 1 events
  Producer A handling demand of 1 with 11
  SlowPipeline: 2, 4, 6
```
