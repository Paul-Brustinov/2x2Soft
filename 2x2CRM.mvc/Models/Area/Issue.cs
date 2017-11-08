using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using _2x2CRM.mvc.Models.Area.Common;

namespace _2x2CRM.mvc.Models.Area
{
    public class Issue : IEntity
    {
        [Key]
        public Int64 Id { get; set; }

        [Display(Name = "Date")]
        public DateTime OpDate { get; set; }
        public Int64 ClientId { get; set; }
        public Int64 SuppId { get; set; }
        public IList<IssueDetail> IssueDetails { get; set; }


        private string _name;

        public Issue()
        {
            Id = 0;
            ClientId = 0;
            IssueDetails = new List<IssueDetail> {new IssueDetail()};
            OpDate = DateTime.Today;
        }

        public Person Client { get; set; }

        public Person Supporter { get; set; }

        public string ClientName => Client == null ? "not selected" : Client.Name;
        public string SupporterName => Supporter == null ? "not selected" : Supporter.Name;

        public string Date => OpDate.ToString("dd.MM.yyyy");

        public string Name { get; set; }

    }
}