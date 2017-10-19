using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin;
using _2x2Soft.Infrastructure;

namespace _2x2CRM.mvc.Models.UserIdentity
{
    public class AppUserManager : UserManager<AppUser, long>
    {
        public AppUserManager(IUserStore<AppUser, long> store) : base(store)
        {
            this.PasswordHasher = new PasswordHasher();
        }

        void Construct(IdentityFactoryOptions<AppUserManager> options)
        {
            // Configure validation logic for usernames
            UserValidator = new UserValidator<AppUser, long>(this)
            {
                AllowOnlyAlphanumericUserNames = false,
                RequireUniqueEmail = true
            };

            // Configure validation logic for passwords
            PasswordValidator = new PasswordValidator
            {
                RequiredLength = 6 //TODO:,
                                   //RequireNonLetterOrDigit = true,
                                   //RequireDigit = true,
                                   //RequireLowercase = true,
                                   //RequireUppercase = true,
            };

            // Configure user lockout defaults
            UserLockoutEnabledByDefault = true;
            DefaultAccountLockoutTimeSpan = TimeSpan.FromMinutes(5);
            MaxFailedAccessAttemptsBeforeLockout = 5;

            /*
            // Register two factor authentication providers. This application uses Phone and Emails as a step of receiving a code for verifying the user
            // You can write your own provider and plug it in here.
            manager.RegisterTwoFactorProvider("Phone Code", new PhoneNumberTokenProvider<ApplicationUser>
            {
                MessageFormat = "Your security code is {0}"
            });
            manager.RegisterTwoFactorProvider("Email Code", new EmailTokenProvider<ApplicationUser>
            {
                Subject = "Security Code",
                BodyFormat = "Your security code is {0}"
            });
            manager.EmailService = new EmailService();
            manager.SmsService = new SmsService();
            */
            var dataProtectionProvider = options.DataProtectionProvider;
            if (dataProtectionProvider != null)
            {
                UserTokenProvider =
                    new DataProtectorTokenProvider<AppUser, Int64>(dataProtectionProvider.Create("ASP.NET Identity"));
            }
        }


        public static AppUserManager Create(IdentityFactoryOptions<AppUserManager> options, IOwinContext context)
        {
            IDbContext dbContext = ServiceLocator.Current.GetService<IDbContext>();
            AppUserStore store = new AppUserStore(dbContext);
            AppUserManager manager = new AppUserManager(store);
            manager.Construct(options);
            return manager;
        }
    }
}