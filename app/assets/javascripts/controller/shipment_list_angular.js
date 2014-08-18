angular.module('shipment_list', []);

function ShipmentListCtrl($scope, $http,$location) {
  var warehouse = $location.search().warehouse;
  var shipment  =  $location.search().shipment;
  var client    = $location.search().client; 
  var url = '/shipmentdetails.json?client=' + client + '&warehouse='+ warehouse;		
  $http.get(url).success(function(data) {
    $scope.shipment_headers = data;
  });
}
