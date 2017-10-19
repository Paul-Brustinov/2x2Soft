using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2x2Soft.Infrastructure
{
    public interface IDataModel
    {
        object Metadata { get; }
        ExpandoObject Root { get; }
        ExpandoObject System { get; }

        T Eval<T>(string expression, T fallback = default(T));
        void Traverse(Func<object, bool> callback);

        string CreateScript();
    }
}
