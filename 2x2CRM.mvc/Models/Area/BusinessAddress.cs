using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace _2x2CRM.mvc.Models.Area
{
    public class BusinessAddress
    {
        public Int64 Id { get; set; }
        public Int64 Index { get; set; }
        public string Street { get; set; }
        public string BuildNo { get; set; }
        public string FlatNo { get; set; }
        public string City { get; set; }
        public string Memo { get; set; }
    }
}