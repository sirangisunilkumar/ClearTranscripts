public with sharing class attachmentViewController {
    public List<Attachment> attachments;
    public String parentId{get;set;}

    public List<Attachment> getAvailableAttachments()
    {
        attachments = new List<Attachment>();
        if (null==attachments || attachments.size()==0)
        {
            attachments=[select Id, ParentId, Name, Description from Attachment where parentId=:parentId order by createddate desc ];
        }
        
        return attachments;
    }
}