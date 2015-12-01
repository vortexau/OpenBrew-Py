    app.controller('SettingsController', ['$scope', function SettingsController($scope) {
        $scope.thing = 'Hello, world!';

        $scope.breweryaddress = '192.168.1.23';
        $scope.breweryaddressport = '1056';

        $scope.fermentoraddress = '192.168.1.62';
        $scope.fermentoraddressport = '1469';

        $scope.kegeratoraddress = '192.168.1.233';
        $scope.kegeratoraddressport = '1272';
    }]);


