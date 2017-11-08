using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using _2x2CRM.mvc.Models.Area.Common;
using _2x2Soft.Infrastructure;

namespace _2x2CRM.mvc.Models.Area
{
    public class IssueDetailStore : Store<IssueDetail>
    {
        public IssueDetailStore(IDbContext dbContext, string name, string schema) : base(dbContext, name, schema)
        {
        }

        public async Task IssueDetailDeleteExcess(Int64 issueId, int no)
        {
            await _dbContext.LoadAsync<Person>(null, _entitySchema + "." + _entityName + "DeleteExcess", new {IssueId = issueId, maxNo = no });
        }
    }
}