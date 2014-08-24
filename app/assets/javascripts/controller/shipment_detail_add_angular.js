var shipment_detail = angular.module('shipment_add', ["xeditable"]);

shipment_detail.run(function(editableOptions) {
  editableOptions.theme = 'bs3';
});


shipment_detail.controller('shipmentAddCtrl', function ($scope, $http, $location) {	
 
  $scope.checkName = function(data) {
    if (data !== 'awesome' && data !== 'error') {
      return "Username should be `awesome` or `error`";
    }
  };

  $scope.saveUser = function() {
    // $scope.user already updated!
      alert($scope.shipment_header.asn_type);	
      alert($scope.shipment_header.shipment_nbr);
   return $http.post('/shipment_details/', {authenticity_token: $('meta[name="csrf-token"]').attr('content'), shipment: $scope.shipment_header}).error(function(err) {
 /*     if(err.field && err.msg) {
        // err like {field: "name", msg: "Server-side error for this username!"} 
        $scope.editableForm.$setError(err.field, err.msg);
      } else { 
        // unknown error
        $scope.editableForm.$setError('name', 'Unknown error!');
      }*/
    });
  };
});