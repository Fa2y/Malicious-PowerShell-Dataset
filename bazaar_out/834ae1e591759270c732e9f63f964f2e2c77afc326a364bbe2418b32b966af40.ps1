[18:06:47 INF] Starting up
[18:06:50 INF] Now listening on: https://localhost:5001
[18:06:50 INF] Now listening on: http://localhost:5000
[18:06:50 INF] Application started. Press Ctrl+C to shut down.
[18:06:50 INF] Hosting environment: Development
[18:06:50 INF] Content root path: /Users/wylie/Documents/Development/boomerServices/CncServices/CncServices.WebApiService
[18:06:50 INF] Request starting HTTP/1.1 GET https://localhost:5001/swagger/index.html  
[18:06:50 INF] Request finished in 66.6238ms 200 text/html;charset=utf-8
[18:06:50 INF] Request starting HTTP/1.1 GET https://localhost:5001/swagger/v1/swagger.json  
[18:06:50 INF] Request finished in 64.1951ms 200 application/json;charset=utf-8
[18:07:46 ERR] Unexpected exception encountered during message processing.  Exception swallowed to allow for retry
System.ObjectDisposedException: Cannot access a closed Stream.
   at System.IO.MemoryStream.set_Position(Int64 value)
   at CncServices.WebApiService.Commands.PointCloudProcessingCommands.ProcessUploadedPointCloudCommandHandler.PerformLodProcessing(ProcessUploadedPointCloudCommand request, PointCloudWithContext pointCloudWithContext) in /Users/wylie/Documents/Development/boomerServices/CncServices/CncServices.WebApiService/Commands/PointCloudProcessingCommands/ProcessUploadedPointCloudCommandHandler.cs:line 64
   at CncServices.WebApiService.Commands.PointCloudProcessingCommands.ProcessUploadedPointCloudCommandHandler.Handle(ProcessUploadedPointCloudCommand request, CancellationToken cancellationToken) in /Users/wylie/Documents/Development/boomerServices/CncServices/CncServices.WebApiService/Commands/PointCloudProcessingCommands/ProcessUploadedPointCloudCommandHandler.cs:line 45
   at MediatR.Pipeline.RequestExceptionProcessorBehavior`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next)
   at MediatR.Pipeline.RequestExceptionProcessorBehavior`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next)
   at MediatR.Pipeline.RequestExceptionActionProcessorBehavior`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next)
   at MediatR.Pipeline.RequestExceptionActionProcessorBehavior`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next)
   at MediatR.Pipeline.RequestPreProcessorBehavior`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next)
   at MediatR.Pipeline.RequestPostProcessorBehavior`2.Handle(TRequest request, CancellationToken cancellationToken, RequestHandlerDelegate`1 next)
   at MediatR.Internal.RequestHandlerWrapperImpl`2.<>c.<Handle>b__0_0(Task`1 t)
   at System.Threading.Tasks.ContinuationResultTaskFromResultTask`2.InnerInvoke()
   at System.Threading.Tasks.Task.<>c.<.cctor>b__274_0(Object obj)
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
--- End of stack trace from previous location where exception was thrown ---
   at System.Threading.ExecutionContext.RunFromThreadPoolDispatchLoop(Thread threadPoolThread, ExecutionContext executionContext, ContextCallback callback, Object state)
   at System.Threading.Tasks.Task.ExecuteWithThreadLocal(Task& currentTaskSlot, Thread threadPoolThread)
--- End of stack trace from previous location where exception was thrown ---
   at CncServices.WebApiService.MessageBus.MessageProcessor.ProcessMessageAsync(Message message) in /Users/wylie/Documents/Development/boomerServices/CncServices/CncServices.WebApiService/MessageBus/MessageProcessor.cs:line 34
   at CncServices.WebApiService.MessageBus.SqsMonitor.ProcessMessageAsync(AmazonSQSClient sqsClient, Message message) in /Users/wylie/Documents/Development/boomerServices/CncServices/CncServices.WebApiService/MessageBus/SqsMonitor.cs:line 124
