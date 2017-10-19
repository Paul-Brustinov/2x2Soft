using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(_2x2CRM.mvc.Startup))]
namespace _2x2CRM.mvc
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            StartServices();
        }
    }
}
