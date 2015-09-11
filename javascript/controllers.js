/**
 * Created by Walter on 9/7/2015.
 */

var portfolio = angular.module("portfolio", ['ui.bootstrap']);

var url = "https://agile-garden-2056.herokuapp.com/";

portfolio.directive('stockChart', function() {
    return {
        restrict: 'EA',
        scope: {
            ticker: '@',
            data: '='
        },
        link: function (scope, element) {
            console.log(element);
            var margin = {top: 20, right: 100, bottom: 30, left: 100};
            var width = element[0].getBoundingClientRect().width - margin.left - margin.right;
            var height = element[0].getBoundingClientRect().height - margin.top - margin.bottom;

            width = 600;
            height = 350;

            var svg = d3.select(element[0]).append("svg")   // this needs to be fixed
                .attr("width", width + margin.left + margin.right)
                .attr("height", height + margin.top + margin.bottom)
                .append("g")
                .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
            var parseDate = d3.time.format("%Y-%m-%d").parse;

            var x = techan.scale.financetime()
                .range([0, width])
                .outerPadding(0);

            var y = d3.scale.linear()
                .range([height, 0]);

            var close = techan.plot.close()
                .xScale(x)
                .yScale(y);

            var xAxis = d3.svg.axis()
                .scale(x)
                .orient("bottom");

            var yAxis = d3.svg.axis()
                .scale(y)
                .orient("left");
            var accessor = close.accessor();
            scope.$watch('data', function (newVal) {
                if (newVal) {
                    newVal.sort(function (a, b) {
                        return d3.ascending(accessor.d(a), accessor.d(b));
                    });
                    console.log("in directive");
                    console.log(newVal.map(accessor.d));
                    console.log(techan.scale.plot.ohlc(newVal, accessor).domain());
                    x.domain(newVal.map(accessor.d));
                    y.domain(techan.scale.plot.ohlc(newVal, accessor).domain());

                    svg.append("g")
                        .datum(newVal)
                        .call(close);

                    svg.append("g")
                        .attr("class", "x axis")
                        .attr("transform", "translate(0," + height + ")")
                        .call(xAxis)
                        .append("text")
                        .attr("y", 6)
                        .attr("dy", ".71em")
                        .style("text-anchor", "end")
                        .text("Date");

                    svg.append("g")
                        .attr("class", "y axis")
                        .call(yAxis)
                        .append("text")
                        .attr("transform", "rotate(-90)")
                        .attr("y", 6)
                        .attr("dy", ".71em")
                        .style("text-anchor", "end")
                        .text("Price ($)");
                }
            });
        }
    }
});

portfolio.controller("SecurityController"), function($scope, $http){
    $scope.add_security = function() {
        var lurl = url + "securities";
      security_params = { "security": {
          "identifier": $scope.identifier,
          "ticker": $scope.ticker,
          "name": $scope.name
      }};
      $http.post(lurl, security_params).success(function(success){
          //on successful add to db
      });
  };
    $scope.get_security = function() {
        var lurl = url + "securities/name/";
        $http.get(lurl + $scope.ticker).success( function(response){
            //check if the security already exists
            $scope.identifier = response.security.identifier;
            $scope.ticker = response.security.ticker;
            $scope.name = response.security.name;
        });
    }
};

portfolio.controller("PortfolioController", function($scope, $http){

    $scope.init_data = function() {
        /*var currentDate = new Date();
        var currentDateString = currentDate.getFullYear() + "-" + ("0" + (currentDate.getMonth() + 1)).slice(-2) + "-" + ("0" + currentDate.getDate()).slice(-2);
        var previousDate = new Date();
        var previousDate = new Date(previousDate.setMonth(currentDate.getMonth() - 3));
        var previousDateString = previousDate.getFullYear() + "-" + ("0" + (previousDate.getMonth() + 1)).slice(-2) + "-" + ("0" + previousDate.getDate()).slice(-2);

        var main = "http://www.quandl.com/api/v1/datasets/" + $scope.stock.dataset + ".json";
        var params = "?&trim_start=" + previousDateString + "&trim_end=" + currentDateString;
        var auth = "&auth_token=sok7xuv8xDR_9LooZmaZ";
        var url = main + params + auth;*/
        console.log("in the controller");
        var lurl = url + "backtest";
        var portfolio_id = $scope.portfolio_id;
        var startDate = $scope.start_date;
        var endDate = $scope.end_date;
        var starting_amount = $scope.amount;
        var backtest_params = { "backtest":
            {   "start_date": startDate,
                "end_date":endDate,
                "starting_amount": starting_amount,
                "portfolio_id": portfolio_id
            }};
        $http.post(lurl, backtest_params).success(function (response) {
            var parseDate = d3.time.format("%Y-%m-%d").parse;
            $scope.data = (Object.keys(response)).map(function (value, index) {
                return {
                    date: parseDate(value),
                    open: response[value]['folio'],
                    high: response[value]['folio'],
                    low: response[value]['folio'],
                    close: response[value]['folio'],
                    volume: 0
                };
            });
            console.log($scope.data);
        });
    };
});
