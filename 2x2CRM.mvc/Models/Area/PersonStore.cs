using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using _2x2CRM.mvc.Models.Area.Common;
using _2x2Soft.Infrastructure;

namespace _2x2CRM.mvc.Models.Area
{
    public class PersonStore : Store<Person>
    {
        public PersonStore(IDbContext dbContext, string name, string schema) : base(dbContext, name, schema)
        {
        }

        public async Task<Person> FindByEmailAsync(string email)
        {
            var person = _cache.MapIds.FirstOrDefault(x => x.Value.Emails.Any(e => e.Value == email)).Value;
            if (person != null) return person;

            person = await _dbContext.LoadAsync<Person>(null, _entitySchema + "." + _entityName + "FindByEmail", new { Email = email });
            _cache.CacheEntity(person);
            return person;
        }

    }
}