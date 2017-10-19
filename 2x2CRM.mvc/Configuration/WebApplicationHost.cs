using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using _2x2Soft.Infrastructure;

namespace _2x2CRM.mvc.Configuration
{
    public class WebApplicationHost : IApplicationHost
    {
        IProfiler _profiler;
        IDictionary<String, String> _cnnStrings = new Dictionary<String, String>();

        public WebApplicationHost(IProfiler profiler)
        {
            _profiler = profiler;
        }

        #region IConfiguration
        public IProfiler Profiler => _profiler;

        public String ConnectionString(String source)
        {
            if (String.IsNullOrEmpty(source))
                source = "Default";

            String cnnStr = null;
            if (_cnnStrings.TryGetValue(source, out cnnStr))
                return cnnStr;
            var strSet = ConfigurationManager.ConnectionStrings[source];
            if (strSet == null)
                throw new ConfigurationErrorsException($"Connection string '{source}' not found");
            cnnStr = strSet.ConnectionString;
            _cnnStrings.Add(source, strSet.ConnectionString);
            return cnnStr;
        }

        public String AppPath
        {
            get
            {
                String path = ConfigurationManager.AppSettings["appPath"];
                if (path == null)
                    throw new ConfigurationErrorsException("Configuration parameter 'appSettings/appPath' not defined");
                return path;
            }
        }

        public String AppKey
        {
            get
            {
                // TODO: ???
                return ConfigurationManager.AppSettings["appKey"];

            }
        }

        public async Task<String> ReadTextFile(Boolean bAdmin, String path, String fileName)
        {
            String fullPath = MakeFullPath(bAdmin, path, fileName);
            using (var tr = new StreamReader(fullPath))
            {
                return await tr.ReadToEndAsync();
            }
        }

        public Boolean IsDebugConfiguration { get { return true; } }

        public String MakeFullPath(Boolean bAdmin, String path, String fileName)
        {
            String appKey = bAdmin ? "admin" : AppKey;
            String fullPath = Path.Combine($"{AppPath}/{appKey}", path, fileName);
            return Path.GetFullPath(fullPath);
        }
        #endregion

        public String AppVersion => AppInfo.MainAssembly.Version;
    }
}
