using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _2x2Soft.Infrastructure
{
    public interface IDbContext
    {
        string ConnectionString(string source);
        Task<SqlConnection> GetConnectionAsync(string source);
        IDataModel LoadModel(string source, string command, object prms = null);
        Task<IDataModel> LoadModelAsync(string source, string command, object prms = null);
        Task<IDataModel> SaveModelAsync(string source, string command, object data, object prms = null);

        Task<T> LoadAsync<T>(string source, string command, object prms = null) where T : class;
        Task<IList<T>> LoadListAsync<T>(string source, string command, object prms) where T : class;

        void Execute<T>(string source, string Command, T element) where T : class;
        Task ExecuteAsync<T>(string source, string command, T element) where T : class;

        void SaveList<T>(string source, string command, object prms, IEnumerable<T> list) where T : class;
        Task SaveListAsync<T>(string source, string command, object prms, IEnumerable<T> list) where T : class;

    }
}
