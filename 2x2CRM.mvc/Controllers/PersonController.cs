using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using _2x2CRM.mvc.Models.Area;
using _2x2Soft.Infrastructure;

namespace _2x2CRM.mvc.Controllers
{
    public class PersonController : Controller
    {

        private readonly IDbContext _dbContext;
        private readonly PersonStore _store;

        public PersonController()
        {
            _dbContext = ServiceLocator.Current.GetService<IDbContext>();
            _store = new PersonStore(_dbContext);
        }

        // GET: Person
        [Authorize]
        public async Task<ActionResult> Index(int id=1)
        {
            IEnumerable<Person> Persons =  await _store.GetPage(id, 20);
            return View(Persons);
        }

        [Authorize]
        public async Task<ActionResult> Edit(long id)
        {
            Person person = await _store.FindByIdAsync(id);
            return View(person);
        }

        [HttpPost]
        [Authorize]
        public async Task<ActionResult> Edit(Person person)
        {
            await _store.UpdateAsync(person);
            return View(person);
        }

        [Authorize]
        public async Task<ActionResult> Details(long id)
        {
            Person person = await _store.FindByIdAsync(id);
            return View(person);
        }

        [Authorize]
        public ActionResult Create()
        {
            Person person = new Person();
            return View(person);
        }

        [HttpPost]
        [Authorize]
        public async Task<ActionResult> Create(Person person)
        {
            await _store.CreateAsync(person);
            return View(person);
        }

        [Authorize]
        public async Task<ActionResult> Delete(long id)
        {
            await _store.DeleteAsync(id);
            if (HttpContext.Request.UrlReferrer != null)
                return Redirect(HttpContext.Request.UrlReferrer.AbsolutePath);

            return RedirectToAction("Index");
        }



    }
}