app.service('save', function($http) {
  this.start = function(data, url) {
    var promise = $http({
      method: 'POST',
      url: url,
      data: data
    });

    return promise;
  }
});
