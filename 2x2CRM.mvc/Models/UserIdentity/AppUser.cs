using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.Identity;

namespace _2x2CRM.mvc.Models.UserIdentity
{
    [Flags]
    public enum UserModifiedFlag
    {
        Default = 0,
        Lockout = 0x0001,
        Password = 0x0002
    }

    public class AppUser : IUser<long>
    {

        public AppUser(long id) { Id = id; }
        public AppUser() { Id = 0; }

        #region IUser<long>
        public long Id { get; set; }
        public string UserName { get; set; }
        #endregion

        public String PersonName { get; set; }
        public String Email { get; set; }
        public String PhoneNumber { get; set; }

        public String PasswordHash { get; set; }
        public String SecurityStamp { get; set; }
        public DateTimeOffset LockoutEndDateUtc { get; set; }
        public Boolean LockoutEnabled { get; set; }
        public Int32 AccessFailedCount { get; set; }
        public Boolean TwoFactorEnabled { get; set; }
        public Boolean EmailConfirmed { get; set; }
        public Boolean PhoneNumberConfirmed { get; set; }

        public string Guid { get; set; }
        UserModifiedFlag _modifiedFlag;

        public void SetModified(UserModifiedFlag flag)
        {
            _modifiedFlag |= flag;
        }

        public void ClearModified(UserModifiedFlag flag)
        {
            _modifiedFlag &= ~flag;
        }

        public Boolean IsLockoutModified => _modifiedFlag.HasFlag(UserModifiedFlag.Lockout);

        public bool IsPasswordModified => _modifiedFlag.HasFlag(UserModifiedFlag.Password);

        public string Locale { get; set; }
        public string Memo { get; set; }

        public async Task<ClaimsIdentity> GenerateUserIdentityAsync(UserManager<AppUser, long> manager)
        {
            // Note the authenticationType must match the one defined in CookieAuthenticationOptions.AuthenticationType
            var userIdentity = await manager.CreateIdentityAsync(this, DefaultAuthenticationTypes.ApplicationCookie);
            // Add custom user claims here
            return userIdentity;
        }
    }
}