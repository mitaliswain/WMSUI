var shipment_detail = angular.module('shipment_detail', ["xeditable"]);

shipment_detail.run(function(editableOptions) {
  editableOptions.theme = 'bs3';
});


shipment_detail.controller('shipmentCtrl', function ($scope, $http, $location) {	
  var warehouse = $location.search().warehouse;
  var shipment  =  $location.search().shipment;
  var client    = $location.search().client; 
  var url = '/shipmentdetails/'+  shipment + '.json?client=' + client + '&warehouse='+ warehouse;	
  $http.get(url).success(function(data) {
    $scope.shipment_header = data.shipment_header;
    $scope.shipment_details = data.shipment_detail;
    
  });

 $scope.updateHeader = function(data, el, id) {

    var warehouse = $location.search().warehouse;
    var shipment  =  $location.search().shipment;
    var client    = $location.search().client; 
    var url = '/shipment_details/'+ id + '/update_header?client=' + client + '&warehouse='+ warehouse;	
    return $http.post(url, {
    	'authenticity_token': $('meta[name="csrf-token"]').attr('content'),
    	shipment: {'client': 'WM', 'warehouse': 'WH1'},
    	field_to_update: {'column': el.$editable.elem[0].id, 'value': data}
    	});
 };
  
 $scope.updateDetail = function(data, el, id) {

    var warehouse = $location.search().warehouse;
    var shipment  =  $location.search().shipment;
    var client    = $location.search().client; 
    var url = '/shipment_details/'+ id + '/update_detail?client=' + client + '&warehouse='+ warehouse;	
    return $http.post(url, {
    	'authenticity_token': $('meta[name="csrf-token"]').attr('content'),
    	shipment: {'client': 'WM', 'warehouse': 'WH1'},
    	field_to_update: {'column': el.$editable.elem[0].id, 'value': data}
    	});

 };
  

});