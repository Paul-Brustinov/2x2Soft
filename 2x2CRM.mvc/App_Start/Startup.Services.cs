using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using _2x2CRM.mvc.Configuration;
using _2x2Soft.Data;
using _2x2Soft.Infrastructure;

namespace _2x2CRM.mvc
{
    public partial class Startup
    {
        public void StartServices()
        {
            // DI ready
            IServiceLocator locator = ServiceLocator.Current;
            IProfiler profiler = new WebProfiler();
            IApplicationHost host = new WebApplicationHost(profiler);
            IDbContext dbContext = new SqlDbContext(host);
            //IRenderer renderer = new XamlRenderer();
            //IWorkflowEngine workflowEngine = new WorkflowEngine(host, dbContext);

            locator.RegisterService<IDbContext>(dbContext);
            locator.RegisterService<IProfiler>(profiler);
            locator.RegisterService<IApplicationHost>(host);
            //locator.RegisterService<IRenderer>(renderer);
            //locator.RegisterService<IWorkflowEngine>(workflowEngine);

        }
    }
}