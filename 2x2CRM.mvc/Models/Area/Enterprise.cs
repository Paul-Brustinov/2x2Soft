using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _2x2CRM.mvc.Models.Area
{
    public class Enterprise : Person
    {
        public List<Human> Employees { get; set; }

        public Enterprise():base()
        {
            Employees = new List<Human>();
        }
    }
}