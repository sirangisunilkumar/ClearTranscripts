public with sharing class FileUploadController{
    public String parentId{get;set;}
    pageReference currentPage;
    public String contentType {get; set;}
    public String currentPanel{get;set;}
    public Boolean isRedirectURL{get;set;}
    
    
    public Attachment attachment 
    {
      get {
          if (attachment == null)
            attachment = new Attachment();
          return attachment;
        }
      set;
    }
    
    public FileUploadController()
    {
        parentId = ApexPages.currentPage().getParameters().get('parentId');
        currentPage = Apexpages.currentPage();
        currentPage.getParameters().putAll(ApexPages.currentPage().getParameters());
        currentPage.setRedirect(true);
    }

    public pagereference upload() 
    {
        
        if(currentPanel != null)
        {
            currentPage.getParameters().put('activep',currentPanel);
        }
        if(parentId != null)
        {
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = parentId; 
            
            try
            {
                insert attachment;
                
            }
            catch(Exception e)
            {
                system.debug('Attachment Upload: '+e.getMessage());
            }
            finally
            {
                attachment.body = null;
                attachment = new attachment();
            }
            system.debug('pageURL: '+currentPage);
            return currentPage;
        }
        else
        {
            system.debug('Parent id not found');
            return currentPage;
        }   
    }
    
        
    
}