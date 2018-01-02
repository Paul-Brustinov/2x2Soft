using System;
using System.Collections.Generic;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Newtonsoft.Json;
using WebGrease.Css.Extensions;
using _2x2CRM.mvc.Cors;
using _2x2CRM.mvc.Models.Area;
using _2x2CRM.mvc.Models.Area.Common;
using _2x2Soft.Infrastructure;

namespace _2x2CRM.mvc.Controllers
{

    [Authorize]
    public class IssueController : Controller
    {

        private readonly IDbContext _dbContext;
        private readonly PersonStore _storePerson;
        private readonly IssueStore _storeIssue;
        private readonly IssueDetailStore _storeIssueDetail;
        private Person _suppPerson;
        private readonly string _email;

        public IssueController()
        {
            _dbContext = ServiceLocator.Current.GetService<IDbContext>();
            _storePerson = new PersonStore(_dbContext, "Person", "Crm");
            _storeIssue = new IssueStore(_dbContext, "Issue","Crm");
            _storeIssueDetail = new IssueDetailStore(_dbContext, "IssueDetail", "Crm");

            _email = System.Web.HttpContext.Current.User.Identity.Name;
        }

        //[AllowCrossSite]
        public async Task<JsonResult> MyIssuesJson()
        {
            if (!User.Identity.IsAuthenticated) return Json("Need to login");
            _suppPerson = await _storePerson.FindByEmailAsync(_email);

            dynamic model = new ExpandoObject();
            model.Email = _email;

            IEnumerable<Person> persons = await _storePerson.GetAll();
            List<Entity> entities = new List<Entity>();
            //To restrict information sending to client, send only Id and Name
            persons.ForEach(p => { entities.Add(new Entity() { Id = p.Id, Name = p.Name }); });
            model.Persons = entities;

            IEnumerable<Issue> issues = await _storeIssue.GetSuppIssues(_suppPerson.Id);

            issues = issues.OrderByDescending(x => x.OpDate);
            foreach (var issue in issues)
            {
                issue.Client = persons.FirstOrDefault(p => p.Id == issue.ClientId);
                issue.Supporter = persons.FirstOrDefault(p => p.Id == issue.SuppId);
            }

            model.Issues = issues;

            return Json(model, JsonRequestBehavior.AllowGet);
        }


        public async Task<ActionResult>MyIssues()
        {

            if (!User.Identity.IsAuthenticated)
                return Json("Need to login");

            _suppPerson = await _storePerson.FindByEmailAsync(_email);

            IEnumerable<Person> persons = await _storePerson.GetAll();
            List<Entity> entities = new List<Entity>();
            //To restrict information sending to client, send only Id and Name
            persons.ForEach(p => { entities.Add(new Entity() { Id = p.Id, Name = p.Name }); });
            ViewBag.persons = entities;

            //var _suppPersonPromise =  _storePerson.FindByEmailAsync(_email);

            Issue i = new Issue();
            
            //var FieldName = typeof(Issue)
            //    .GetProperty("OpDate")
            //    .CustomAttributes.FirstOrDefault(
            //        a => a.AttributeType.FullName == "System.ComponentModel.DataAnnotations.DisplayAttribute")
            //    .NamedArguments.FirstOrDefault(a => a.MemberName == "Name")
            //    .TypedValue.ToString();

            var n = i.GetType().GetProperty("OpDate").CustomAttributes.ToList();
            IEnumerable<Issue> issues = await _storeIssue.GetSuppIssues(_suppPerson.Id);

            issues  = issues.OrderByDescending(x => x.OpDate);
            foreach (var issue in issues)
            {
                issue.Client = persons.FirstOrDefault(p => p.Id == issue.ClientId);
                issue.Supporter = persons.FirstOrDefault(p => p.Id == issue.SuppId);
            }

            //_suppPerson = await _suppPersonPromise;
            return View(issues);
        }

        [HttpGet]
        public async Task<ActionResult> AddOrUpdate(Int64 id = 0)
        {
            IEnumerable<Person> persons = await _storePerson.GetAll();
            List<Entity> entities = new List<Entity>();
            Issue issue=null;

            _suppPerson = await _storePerson.FindByEmailAsync(_email);

            //To restrict information sending to client, send only Id and Name
            persons.ForEach(p => {entities.Add(new Entity() {Id = p.Id, Name = p.Name}); });
            if (id == 0)
            {
                Int64 suppId = 0;
                if (_suppPerson != null) suppId = _suppPerson.Id;
                issue = new Issue() {Id = id, OpDate = DateTime.Today, SuppId = suppId, Supporter = _suppPerson};
            }
            else
            {
                issue = await _storeIssue.FindByIdAsync(id);
                issue.Client = await _storePerson.FindByIdAsync(issue.ClientId);
                issue.Supporter = await _storePerson.FindByIdAsync(issue.SuppId);
                issue.IssueDetails = await _storeIssue.GetIssueDetails(issue.Id);

            }
            ViewBag.persons = entities;

            return View(issue);
        }


        [HttpGet]
        public async Task<JsonResult> AddOrUpdate2(Int64 id = 0)
        {
            //if (!User.Identity.IsAuthenticated)
            //    return Json("Need to login");
            Issue issue = await _storeIssue.FindByIdAsync(id); ;
            issue.Client = await _storePerson.FindByIdAsync(issue.ClientId);
            issue.Supporter = await _storePerson.FindByIdAsync(issue.SuppId);
            issue.IssueDetails = await _storeIssue.GetIssueDetails(issue.Id);
            return Json(issue, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public async Task Delete(Int64 id = 0)
        {
            await _storeIssue.DeleteAsync(id);
            //return RedirectToAction("MyIssues", "Issue");
        }

        [HttpPost]
        public async Task<long> AddOrUpdate(Issue issue)
        {
            await _storeIssue.AddOrUpdateAsync(issue);

            for (int i = 0; i < issue.IssueDetails.Count; i++)
            {
                issue.IssueDetails[i].IssueId = issue.Id;
                issue.IssueDetails[i].LnNo = i;
                _storeIssueDetail.AddOrUpdateAsync(issue.IssueDetails[i]);
            }
            _storeIssueDetail.IssueDetailDeleteExcess(issue.Id, issue.IssueDetails.Count - 1);

            return issue.Id;
        }


        [HttpPost]
        public async Task<JsonResult> AddOrUpdateJson(Issue issue)
        {
            await _storeIssue.AddOrUpdateAsync(issue);

            for (int i = 0; i < issue.IssueDetails.Count; i++)
            {
                issue.IssueDetails[i].IssueId = issue.Id;
                issue.IssueDetails[i].LnNo = i;
                _storeIssueDetail.AddOrUpdateAsync(issue.IssueDetails[i]);
            }
            _storeIssueDetail.IssueDetailDeleteExcess(issue.Id, issue.IssueDetails.Count - 1);

            return Json(issue.Id);
        }

    }
}