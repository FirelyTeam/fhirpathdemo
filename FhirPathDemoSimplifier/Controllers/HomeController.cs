using System;
using System.Web.Mvc;
using FhirPathDemoSimplifier.ViewModels;
using Hl7.Fhir.Rest;

namespace FhirPathDemoSimplifier.Controllers
{ 
    public class HomeController : Controller
    {
        public ActionResult Index(string endpoint = null)
        {
            ResourceIdentityViewModel resourceEndpoint = null;

            if (!string.IsNullOrEmpty(endpoint))
            {
                var resourceIdentity = new ResourceIdentity(endpoint);

                resourceEndpoint = new ResourceIdentityViewModel()
                {
                    BaseUrl = resourceIdentity.BaseUri.OriginalString,
                    ResourceType = resourceIdentity.ResourceType,
                    ResourceId = resourceIdentity.Id
                };
            }

            return View(resourceEndpoint);
        }
    }
}
