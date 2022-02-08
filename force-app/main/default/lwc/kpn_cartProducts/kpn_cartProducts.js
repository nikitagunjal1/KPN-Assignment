import { LightningElement ,api, wire, track} from 'lwc';
import getOrderedProductsList from '@salesforce/apex/kpn_OrderProductsController.getOrderedProducts';
import upsertOrderPrductsMethod from '@salesforce/apex/kpn_OrderProductsController.upsertOrderPrducts';
import confirmOrderMethod from '@salesforce/apex/kpn_OrderProductsController.confirmOrder';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
export default class LightningDatatableLWCExample extends LightningElement {
    @track columns = [{
            label: 'Name',
            fieldName: 'productName',
            type: 'text',
            sortable: true
        },
        {
            label: 'Unit Price(€)',
            fieldName: 'UnitPrice',
            type: 'text',
            sortable: true
        },
        {
            label: 'Quantity',
            fieldName: 'Quantity',
            type: 'text',
            sortable: true
        },
        {
            label: 'Total Price(€)',
            fieldName: 'TotalPrice',
            type: 'text',
            sortable: true
        }
    ];
    @api recordId;
    @track error;
    @api prdList;
    @track updatedOrdrList =[];
    @track buttonDisable=false;
    /*
 	* Method Name :connectedCallback
	* Purpose : connectedCallback method to get existing Order Items
 	*/
    connectedCallback() {
        getOrderedProductsList({ordrId: this.recordId})
        .then(result => {
            console.log('in getOrderedProductsList');
            if(result.length>0){
                if(result[0].Order.Status=='Activated'){
                    this.buttonDisable = true; //to disable add button  
                    //custom event
                }
                const passEvent = new CustomEvent('buttondisable', {
                    detail:this.buttonDisable
                });
                this.dispatchEvent(passEvent);    

                this.updatedOrdrList = result.map(
                record => Object.assign(
                { "productName": record.Product2.Name},record)
                );          
            }
        })
        .catch(error => {
            this.error = JSON.stringify(error.body.message);
            const evt = new ShowToastEvent({
                title: 'Error',
                message: this.error,
                variant: 'Error',
                mode: 'Dismissible'
            });
            this.dispatchEvent(evt);
        });
    }
    /*
 	* Method Name :handleValueChange
	* Purpose : event method called from parent to get retrieve new Order Item selected
 	*/
    @api handleValueChange(val) {
       console.log('in handleValueChange');
     
       let isExist= false;
       let tempPrdList= this.updatedOrdrList;
       
       tempPrdList.forEach(element => {
            if(element.Product2Id == val.Product2Id )
            {   
                //console.log('selected product is already in the cart');
                element.Quantity=element.Quantity+1;
                element.TotalPrice=element.TotalPrice+val.UnitPrice;  
                isExist = true;
            }       
        });        
        if(!isExist)
        {       
            let recordVal = {
                apiName: 'OrderItem',
                productName: val.ProductName,
                Quantity: 1,
                TotalPrice: val.UnitPrice,
                UnitPrice: val.UnitPrice,
                Product2Id:val.Product2Id,
                ProductCode:val.Product2.ProductCode,
                OrderId:this.recordId,
                PricebookEntryId:val.Id            
            }            
            tempPrdList.push(recordVal);            
        }
        this.updatedOrdrList =[...tempPrdList];
        
    }
    
    /*
    * Method Name :handleClick
    * Purpose : Method is used to save/update selected Order Items and disable 
    * confirm order button
    */
    handleClick(event){
        //console.log('In handleClick');        
        let orderProductIdList;      
        /*
        Created spearate methods for Upsert OLI and Confirm Order callout. 
        We face "you have uncommitted work pending. please commit or rollback before calling out" error,
        if we make a callout after DML transaction. Future method could have used to spearate the transaction
        and avoid the error. But we need the response in the same transactio to deactivate the confirm & add
        button based on Successful response which wouldnt have possible with future method. So I have called 
        confirmOrderMethod() from upsertOrderPrductsMethod().In LWC, 2 different methods call are treated as
        separate transaction. This approach also allowed to get the real time response in same transaction.
        */
        upsertOrderPrductsMethod({'updatedOrdrList': this.updatedOrdrList}) 
        .then(result => {
            //console.log('In  upsertOrderPrductsMethod');
            orderProductIdList = result;

            confirmOrderMethod({'orderProductIdList': result,
            'ordrId': this.recordId})
                .then(result => {
                //console.log('In Confirm Order');                
                if(result.Status=='Activated'){
                    //show toast notification                    
                    const evt = new ShowToastEvent({
                        title: 'Success',
                        message: 'Order Confirmed Successfully',
                        variant: 'Success',
                        mode: 'Dismissible'
                    });
                    this.dispatchEvent(evt);
                    
                    //custom event to disable buttons
                    this.buttonDisable = true;
                    const passEvent = new CustomEvent('buttondisable', {
                        detail:this.buttonDisable
                    });
                   
                    this.dispatchEvent(passEvent);
                }
				else{
                    //show toast notification                    
                    const evtErr = new ShowToastEvent({
                        title: 'Error',
                        message: 'Invalid Order',
                        variant: 'Error',
                        mode: 'Dismissible'
                    });
                    this.dispatchEvent(evtErr);
                }
			})
            .catch(error => {
                console.log('error1- '+JSON.stringify(error));
                console.error(error);
                this.error = JSON.stringify(error);
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: this.error,
                    variant: 'Error',
                    mode: 'Dismissible'
                });
                this.dispatchEvent(evt);
            });
    
        })
        .catch(error => {
            //console.log('error2- '+JSON.stringify(error.body.message));          
            this.error = JSON.stringify(error.body.message);
            const evt = new ShowToastEvent({
                title: 'Error',
                message: this.error,
                variant: 'Error',
                mode: 'Dismissible'
            });
            this.dispatchEvent(evt);
        });
    }
}