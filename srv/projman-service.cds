using sfsf.projman.model.db as model from '../db/projman-model';
using PLTUserManagement as UM_API from '../srv/external/PLTUserManagement.csn';

namespace sfsf.projman.service;

service ProjectManager @(
    path    : '/projman',
    requires: 'authenticated-user'
) {
    @odata.draft.enabled
    entity Project   as projection on model.Project;

    entity Member    as
        select from model.Member {
            *,
            member.defaultFullName as member_name
        };

    entity Activity  as projection on model.Activity;

    @readonly
    entity SFSF_User as
        select from UM_API.User {
            key userId,
                username,
                defaultFullName,
                email,
                division,
                department,
                title
        };

    annotate Project with @(requires: 'Admin');
    annotate Member with @(requires: 'Admin');
    annotate Activity with @(requires: 'Admin');
    annotate SFSF_User with @(requires: 'Admin');
    annotate SFSF_User with @(cds.odata.valuelist);
}
