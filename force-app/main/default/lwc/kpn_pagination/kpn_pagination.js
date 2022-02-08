import { LightningElement, api, track, wire } from 'lwc';
/* Client side pagination is used considering total number of products are less than 50K */
export default class Pagination extends LightningElement {
    @track visibleProducts;
    currentPage =1;
    totalRecords;
    recordSize = 5;
    totalPage = 0;

  
    get records(){
        return this.visibleRecords;
    }

    
    @api 
    set records(data){
        if(data){ 
            this.totalRecords = data;      
            this.recordSize = Number(this.recordSize);
            this.totalPage = Math.ceil(data.length/this.recordSize);
            this.updateRecords();
        }
    }

    /*
 	* Method Name :disablePrevious
	* Purpose     :Disable Previous button if user is on first page
 	*/
    get disablePrevious(){ 
        return this.currentPage<=1;
    }

    /*
 	* Method Name :disableNext
	* Purpose     :Disable Next button if user is on last page
 	*/
    get disableNext(){ 
        return this.currentPage>=this.totalPage;
    }

    /*
 	* Method Name :previousHandler
	* Purpose     :Calculate page number on click of Previous button
 	*/
    previousHandler(){ 
        if(this.currentPage>1){
            this.currentPage = this.currentPage-1;
            this.updateRecords();
        }
    }

    /*
 	* Method Name :nextHandler
	* Purpose     :Calculate the page number on click of Next button
 	*/
    nextHandler(){
        if(this.currentPage < this.totalPage){
            this.currentPage = this.currentPage+1;
            this.updateRecords();
        }
    }

    /*
 	* Method Name :updateRecords
	* Purpose     :update the order items list which needs to be displayed in table as per the start and end index
 	*/
    updateRecords(){     
      
        const start = (this.currentPage-1)*this.recordSize;        
        const end = this.recordSize*this.currentPage;        
        this.visibleRecords = this.totalRecords.slice(start, end);       
        const paginationevent = new CustomEvent('update', {
            detail:this.visibleRecords
        });
        this.dispatchEvent(paginationevent);
        
    }
}