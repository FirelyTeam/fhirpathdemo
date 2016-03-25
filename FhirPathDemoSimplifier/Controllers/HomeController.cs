using System.Web.Mvc;

namespace FhirPathDemoSimplifier.Controllers
{ 
    public class HomeController : Controller
    {
        public ActionResult Index(string endpoint = null)
        {
            var resourceEndpoint = new ResourceReferenceViewModel()
            {
                BaseUrl = "https://localhost:44302/api/fhir",
                ResourceType = "NamingSystem",
                ResourceId = "spark4"
            };

            return View(resourceEndpoint);
        }
    }

    public class ResourceReferenceViewModel
    {
        public string BaseUrl { get; set; }

        public string ResourceType { get; set; }

        public string ResourceId { get; set; }

    }
}
