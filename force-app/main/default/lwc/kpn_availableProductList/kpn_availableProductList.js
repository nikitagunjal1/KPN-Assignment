import { LightningElement ,api, wire, track} from 'lwc';
import getProductList from '@salesforce/apex/kpn_AvailableProductsController.getAllProducts';
import { getRecord, getRecordNotifyChange } from 'lightning/uiRecordApi';
export default class LightningDatatableLWCExample extends LightningElement {
    @api totalProducts;
    @api visibleProducts;
    @api recordId;
    @track error;
    @api prdList;
    @api buttonDisable=false;
    @track columns = [{
            label: 'Name',
            fieldName: 'ProductName',
            type: 'text',
            sortable: true
        },
        {
            label: 'List Price(€)',
            fieldName: 'unitPrice',
            type: 'text',
            sortable: true
        },
        {
            type:  'button',
            label: 'Add To Cart',
            typeAttributes: 
            {
              iconName: 'action:new',
              name: 'AddRecord', 
              title: 'AddRecord', 
              disabled: {fieldName:'buttonCheck'}, 
              value: 'test'
            }
        }
    ];
 
    /*
 	* Method Name :connectedCallback
	* Purpose     :connectedCallback method to get available products
 	*/
    connectedCallback(){
        this.getListOfProducts();
    }

   
     /*
 	* Method Name :handleRowAction
	* Purpose : On Click of Plus button of any row pass data to child component
 	*/
     handleRowAction(event) {
        //console.log('in handleRowAction');
        this.row = event.detail.row;
        this.template.querySelector("c-kpn_cart-products").handleValueChange(this.row);
        
    }

     /*
 	* Method Name :handlebuttondisable
	* Purpose : Event method fired from child to disable plus button if 
                Status is already activated
 	*/
     handlebuttondisable(event){
        //console.log('inside handlebuttondisable method');
        this.buttonDisable = event.detail;   
        this.getListOfProducts();
    }

    /*
 	* Method Name :handleUpdate
	* Purpose : Event method fired from child to display sliced list of products 
 	          based on start and end index
    */
    handleUpdate(event){
        //console.log('In handle update method');       
        this.visibleProducts=[...event.detail];
        //console.log('this.visibleproducts--'+JSON.stringify(this.visibleProducts));
    }

    /*
 	* Method Name :getListOfProducts
	* Purpose     :Method to get list of available products and pass to the datatable
    */

    getListOfProducts(){
        //console.log('in getlistofproducts');
        getProductList({orderId: '$recordId'})
        .then(result=>{
            //console.log('result.data--'+JSON.stringify(result))
            let tempPrdlst;
            this.prdList = result.map(
                record => Object.assign(
                    {
                        "ProductName":record.Product2.Name,
                        "ProductCode":record.Product2.ProductCode,
                        "buttonCheck":this.buttonDisable,
                        "unitPrice":record.UnitPrice
                    },
                    record)
                );
            //console.log('this.prdList'+this.prdList);
            tempPrdlst = this.prdList;
            this.totalProducts = this.prdList;;
        }).catch(error=>{
            this.error = error;
        });
    }
 
   
}