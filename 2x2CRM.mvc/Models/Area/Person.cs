using System.Collections.Generic;
using Microsoft.Owin.BuilderProperties;
using Newtonsoft.Json;

namespace _2x2CRM.mvc.Models.Area
{
    public class Person
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Code { get; set; }

        public int Type { get; set; }

        [JsonIgnore]
        public List<Phone> Phones { get; set; }

        [JsonIgnore]
        public List<Email> Emails { get; set; }
        //public List<BusinessAddress> Addresses { get; set; }

        public string Memo { get; set; }

        public Person()
        {
            Phones = new List<Phone>();
            Emails = new List<Email>();
            //Addresses = new List<BusinessAddress>();
        }
        
    }
}