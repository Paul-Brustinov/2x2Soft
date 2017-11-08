using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using _2x2CRM.mvc.Models.Area.Common;

namespace _2x2CRM.mvc.Models.Area
{
    public class IssueDetail:IEntity
    {
        public Int64 Id { get; set; }

        public Int64 IssueId { get; set; }

        public int LnNo { get; set; }

        public string Description { get; set; }

        public decimal Hours { get; set; }

        public IssueDetail()
        {
            Id = 0;
            Hours = 0;
            LnNo = 0;
        }
    }
}