var OptionsBox = React.createClass({displayName: 'OptionsBox',

    highlighter: function (li, query) {
        regexp = new RegExp("\\s*(\\w*?)(" + query.replace("+","\\+") + ")(\\w*)\\s*", 'ig');
        return li.replace(regexp, function(str, $1, $2, $3) {
          return ' ' + $1 + '<strong>' + $2 + '</strong>' + $3 + ' ';
        });
    },

    render: function () {
        var optionBoxStyle = this.props.conf;
        optionBoxStyle['position'] = 'absolute';

        var options = this.props.conf.data;
        var selectedOpt = this.props.conf.selectedOpt;
        var query = this.props.query;

        return (
            <div style={optionBoxStyle} className="options-box">
                <ul>
                    {options.map(function(option, index) {
                        if(index === selectedOpt) {
                            return <li key={option.id} className="selected" onClick={this.props.onItemClicked} dangerouslySetInnerHTML={{__html: this.highlighter(option.displayText, query)}} />;
                        } else {
                            return <li key={option.id} onMouseOver={this.props.onItemHovered.bind(null, index)} dangerouslySetInnerHTML={{__html: this.highlighter(option.displayText, query)}} />;
                        }
                    }.bind(this))}
                </ul>
            </div>
        );
    }
});
