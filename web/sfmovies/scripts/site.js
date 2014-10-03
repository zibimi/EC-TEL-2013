var SFMovies=SFMovies||{};

SFMovies.Location=Backbone.Model.extend({
    defaults:{
        locations:''
    }
});

SFMovies.LocationCollection=Backbone.Collection.extend({
    model:SFMovies.Location,
    url:"search.php"
});

SFMovies.LocationView=Backbone.View.extend({
    tagName:"li",
    template:_.template($("#tpl-location").html()),
    render:function(){
        this.$el.html(this.template(this.model.toJSON()));
        return this;
    }
});

var AppView=Backbone.View.extend({
    el:"#container",
    initialize:function(){
        this.collection=new SFMovies.LocationCollection();
        this.listenTo(this.collection,'reset',this.render);
        var options={
            zoom:8,
            mapTypeId:google.maps.MapTypeId.ROADMAP
        };
        this.map=new google.maps.Map(document.getElementById("map"),options);
        this.markers=[];
        this.geocoder=new google.maps.Geocoder();
        var that=this;
        this.geocoder.geocode({
            'address':'San Francisco'
        },function(results,status){
            if(status==google.maps.GeocoderStatus.OK){
                that.map.setCenter(results[0].geometry.location);
            }
        });
    },
    render:function(){
        this.$el.find(".loading").hide();
        this.$el.find("#results").html("");
        this.collection.each(function(location){
            this.renderLocation(location);
        },this);
    },
    renderLocation:function(location){
        var locationView=new SFMovies.LocationView({
            model:location
        });
        this.$el.find("#results").append(locationView.render().el);
    },
    events:{
        "click .btn":"search",
        "click #results a":"showLocation",
        "click #btn-searchnearby":"searchNearBy"
    },
    search:function(){
        var title=this.$el.find("#txt-title").val();
        var releaseyear=this.$el.find("#txt-releaseyear").val();
        var director=this.$el.find("#txt-director").val();
        this.collection.fetch({
            reset:true,
            remove:true,
            data:{
                title:title,
                releaseyear:releaseyear,
                director:director
            }
        });
        this.$el.find(".loading").show();
    },
    showLocation:function(e){
        var that=this;
        var o=$(e.currentTarget);
        this.$el.find("#results a").removeClass("active");
        o.addClass("active");
        var address=o.html();
        if(address.indexOf(" from ")!=-1){
            if(address.indexOf(" to ")!=-1){
                address=address.substr(address.lastIndexOf(" to ")+4);
            }
            else{
                address=address.substr(address.indexOf(" from ")+6);
            }
        }
        this.geocoder.geocode({
            'address':address+', San Francisco, CA'
        },function(results,status){
            for(var i in that.markers){
                that.markers[i].setMap(null);
            }
            that.markers=[];
            if(status==google.maps.GeocoderStatus.OK){
                that.map.setCenter(results[0].geometry.location);
                var marker=new google.maps.Marker({
                    map:that.map,
                    position:results[0].geometry.location
                });
                that.markers.push(marker);
            }
        });
    },
    searchNearBy:function(){
        var location=this.$el.find("#txt-location").val();
        this.geocoder.geocode({
            'address':location
        },function(results,status){
            if(status==google.maps.GeocoderStatus.OK){
                console.log(results[0].geometry);
            }
        });
    }
});

$(function(){
    new AppView();
});