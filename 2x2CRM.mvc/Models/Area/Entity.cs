using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using _2x2CRM.mvc.Models.Area.Common;

namespace _2x2CRM.mvc.Models.Area
{
    public class Entity : IEntity
    {
        public Int64 Id { get; set; }
        public string Name { get; set; }
    }
}