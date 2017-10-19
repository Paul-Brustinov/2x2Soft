using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity;

namespace _2x2CRM.mvc.Models.UserIdentity
{
    public class AppRole : IRole<long>
    {
        #region IRole<Int64>
        public long Id { get; set; }
        public string Name { get; set; }
        #endregion
    }
}