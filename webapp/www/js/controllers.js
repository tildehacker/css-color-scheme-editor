app.controller('cseCtrl', function($scope, save) {
  $scope.colors = colors;

  $scope.save = function() {
    save.start($scope.colors, url)
      .then(function(response) {
        $scope.message = response.data;
      }, function(response) {
        $scope.message = "Failure";
      });
  }
});
