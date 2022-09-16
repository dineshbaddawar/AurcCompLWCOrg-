public class ReviewerPortal_Controller {
    
    public ReviewerPortal_Controller(){
        list<Reviwer_Portal_Tabs__c> cdTabs = [select name,Tab_Label__c,id,Controller_Name__c,Display_Order__c from Reviwer_Portal_Tabs__c ORDER BY Display_Order__c];
        
    }
}