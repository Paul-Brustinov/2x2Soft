using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using _2x2CRM.mvc.Models.Area.Common;
using _2x2Soft.Infrastructure;

namespace _2x2CRM.mvc.Models.Area
{
    public class IssueStore : Store<Issue>
    {
        public IssueStore(IDbContext dbContext, string name, string schema ) : base(dbContext, name, schema)
        {
        }

        public Task<IList<Issue>> GetSuppIssues(Int64 suppId)
        {
            return _dbContext.LoadListAsync<Issue>(null, _entitySchema + "." + _entityName + "GetSuppIssues", new { SuppId = suppId });
        }

        public Task<IList<IssueDetail>> GetIssueDetails(Int64 issueId)
        {
            return _dbContext.LoadListAsync<IssueDetail>(null, _entitySchema + "." + _entityName + "GetDetails", new { Id = issueId });
        }

    }
}