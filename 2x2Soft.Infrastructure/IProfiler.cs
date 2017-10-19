using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2x2Soft.Infrastructure
{
    public enum ProfileAction
    {
        Sql,
        Xaml,
        Workflow
    };

    public interface IProfiler
    {
        IDisposable Start(ProfileAction kind, String description);
    }
}
