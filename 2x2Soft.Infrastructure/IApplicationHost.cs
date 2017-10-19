using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2x2Soft.Infrastructure
{
    public interface IApplicationHost
    {
        IProfiler Profiler { get; }
        String AppPath { get; }
        String AppKey { get; }
        Boolean IsDebugConfiguration { get; }

        String ConnectionString(String source);
        String MakeFullPath(Boolean bAdmin, String path, String fileName);
        Task<String> ReadTextFile(Boolean bAdmin, String path, String fileName);

        String AppVersion { get; }
    }
}
