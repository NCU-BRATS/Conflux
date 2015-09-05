KEY_CODE = {
  ESC: 27,
  TAB: 9,
  ENTER: 13,
  CTRL: 17,
  A: 65,
  P: 80,
  N: 78,
  LEFT: 37,
  UP: 38,
  RIGHT: 39,
  DOWN: 40,
  BACKSPACE: 8,
  SPACE: 32
};

var MentionableTextarea = React.createClass({displayName: 'MentionableTextarea',
    getInitialState: function () {
        return {left: '0px', top: '0px', display: 'none', data: [], selectedOpt: 0, currentConf: {},
             cursorPos: 0, flag: '', searchField: '', insertField: '', query: {}, mentionResult: '', stageChoices: [], currentStage: 0};
    },

    matcher: function(flag, subtext, should_startWithSpace, acceptSpaceBar) {
      var _a, _y, match, regexp, space;
      flag = flag.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
      if (should_startWithSpace) {
        flag = '(?:^|\\s)' + flag;
      }
      _a = decodeURI("%C3%80");
      _y = decodeURI("%C3%BF");
      space = acceptSpaceBar ? "\ " : "";
      regexp = new RegExp(flag + "([A-Za-z" + _a + "-" + _y + "0-9_" + space + "\'\.\+\-]*)$|" + flag + "([^\\x00-\\xff]*)$", 'gi');
      match = regexp.exec(subtext);
      if (match) {
        return match[2] || match[1];
      } else {
        return null;
      }
    },

    filter: function(query, data, searchKey) {
      var _results, i, item, len;
      _results = [];
      for (i = 0, len = data.length; i < len; i++) {
        item = data[i];
        if (~new String(item[searchKey]).toLowerCase().indexOf(query.toLowerCase())) {
          _results.push(item);
        }
      }
      return _results;
    },

    hideOptBox: function () {
        this.setState({display: 'none'});
    },

    showOptBox: function () {
        if(!this.isOptBoxVisible()){
            this.resetOptSelected();
        }
        this.setState({display: 'block'});
    },

    resetOptSelected: function () {
        this.setState({selectedOpt: 0});
    },

    /*
    function: prevent unexpected behavior of key event
     */
    filterKey: function (event) {
        if(!event.hasOwnProperty('keyCode'))
            return false;
        switch (event.keyCode) {
            case KEY_CODE.ESC:
                if(!this.isOptBoxVisible()){ // because we hide option box in handleKeyDown,
                                             // we don't want handleMention to show option box again
                    event.preventDefault();
                    return true;
                }
                break;
            case KEY_CODE.DOWN:
            case KEY_CODE.UP:
                return true;
        }
        return false;
    },

    isKeyboardEvent: function (event) {
        return event.hasOwnProperty('keyCode');
    },

    isOptBoxVisible: function () {
        return this.state.display === 'block';
    },

    handleMention: function (event) {
        if(this.filterKey(event)) return;

        if (this.isOptBoxVisible() && this.isKeyboardEvent(event)) {
            this.resetOptSelected();
        }

        var inputorNode = $(React.findDOMNode(this.refs.inputor));

        var offset = inputorNode.caret('offset');

        var inputorTop = inputorNode.offsetParent().offset().top;
        var inputorLeft = inputorNode.offsetParent().offset().left;
        offset.top = offset.top - inputorTop + offset.height;
        offset.left -= inputorLeft;
        delete offset.height;

        this.setState(offset);

        var pos = inputorNode.caret('pos');
        this.setState({cursorPos: pos});

        for(var i=0 ; i<this.props.configurations.targets.length ; i++){
            var conf = this.props.configurations.targets[i];
            var source = inputorNode.val();

            startStr = source.slice(0, pos);
            query = this.matcher(conf.flag, startStr, true);

            // if there is a query string, it means that the flag of
            // current conf is being mentioned
            if (typeof query === "string") {

                // restore where the query string start and end, so that we can replace query string
                // with inserted string when users choose to insert
                var start = pos - query.length;
                var end = start + query.length;
                query = {'text': query, 'headPos': start, 'endPos': end};
                this.setState({query: query});

                // we use local variable currentStage to pretend we have a realtime setState function
                var currentStage = this.state.currentStage;

                // to prevent use choose the first stage but move the cursor to another flag therefore corrupt the component
                if (!this.state.currentConf && conf.flag !== this.state.currentConf.flag) {
                    currentStage = 0;
                    this.resetStage();
                }

                // update current configuration
                this.setState({currentConf: conf});


                var currentStageConf = conf.stages[currentStage];

                // var data = this.fakeFetchData(conf.flag, currentStage);
                currentStageConf.dataFetcher(this.state.stageChoices, function(data){
                    var result = this.filter(query.text, data, currentStageConf.searchField);
                    if(result.length > 0){
                        this.setState({data: result, searchField: currentStageConf.searchField, insertField: currentStageConf.insertField});
                        this.showOptBox();
                    } else {
                        this.hideOptBox();
                        this.resetStage();
                    }
                }.bind(this));

                break;
            } else {
                this.hideOptBox();
            }
        }
    },

    handleKeyDown: function (event) {
        if(!this.isOptBoxVisible()){
            return;
        }
        switch (event.keyCode) {
            case KEY_CODE.DOWN:
                event.preventDefault();
                var newSelected = (this.state.selectedOpt+1) % this.state.data.length;
                this.setState({selectedOpt: newSelected});
                break;
            case KEY_CODE.UP:
                event.preventDefault();
                var newSelected = (this.state.selectedOpt+this.state.data.length-1) % this.state.data.length;
                this.setState({selectedOpt: newSelected});
                break;
            case KEY_CODE.ENTER:
                event.preventDefault();
                this.hideOptBox();
                this.onChoose();
                break;
            case KEY_CODE.ESC:
                this.hideOptBox();
                break;
            default:
                console.log('non handled keydown');
        }
    },

    handleItemClick: function (event) {
        event.preventDefault();
        this.hideOptBox();
        this.onChoose();
    },

    resetStage: function () {
        this.setState({currentStage: 0});
        this.setState({mentionResult: ''});
        this.setState({stageChoices: []});
    },

    /*
    function: called when user select a option in options box
     */
    onChoose: function () {
        var chooseContent = this.state.data[this.state.selectedOpt][this.state.insertField];
        this.state.stageChoices.push(chooseContent);

        var newMentionResult = '';
        if (this.state.mentionResult === '') {
            newMentionResult = this.state.mentionResult + chooseContent;
        } else {
            newMentionResult = this.state.mentionResult + '-' + chooseContent;
        }

        this.setState({mentionResult: newMentionResult}, function () {

            // if current stage is not the final stage, then:
            if (this.state.currentStage+1 < this.state.currentConf.stages.length) {
                // 1. reset the content for search
                this.resetContentAtFlag();

                // 2. increase the currentStage
                this.setState({currentStage: this.state.currentStage+1}, function () {
                    // call handleMention manually, because mouse click on optionBox
                    // wouldn't triggle handleMention to fetch new data
                    this.handleMention({});
                });
                return ;
            }

            this.insertAtCursor(this.state.currentConf.flag + this.state.mentionResult);
            this.resetStage();
        });
    },

    /*
    function: insert content at cursor
    params:
        content[string]: content to insert
    */
    insertAtCursor: function (content) {
        var inputor = $(React.findDOMNode(this.refs.inputor));
        var source = inputor.val();
        var pos = this.state.cursorPos;

        startStr = source.slice(0, Math.max(this.state.query.headPos - this.state.currentConf.flag.length, 0));
        var suffix = " ";
        content += suffix;
        var text = startStr + content + source.slice(query.endPos || 0);

        inputor.val(text);
        inputor.caret('pos', startStr.length + content.length);
        React.findDOMNode(this.refs.inputor).focus();

        this.onContentChange();
    },

    getValueLink: function(props) {
        return props.valueLink || {
                value: props.value,
                requestChange: props.onChange
            };
    },

    componentDidMount: function() {
        var valueLink = this.getValueLink(this.props);
        var inputor = $(React.findDOMNode(this.refs.inputor));
        inputor.val(valueLink.value);
    },

    componentWillReceiveProps: function(nextProps) {
        var valueLink = this.getValueLink(nextProps);
        var inputor = $(React.findDOMNode(this.refs.inputor));
        inputor.val(valueLink.value);
        inputor.change();
    },

    /*
    function: clear content between cursor and last mentioned flag
    */
    resetContentAtFlag: function () {
        var inputor = $(React.findDOMNode(this.refs.inputor));
        var source = inputor.val();
        var pos = this.state.cursorPos;

        startStr = source.slice(0, Math.max(this.state.query.headPos - this.state.currentConf.flag.length, 0));

        var text = startStr + this.state.currentConf.flag + source.slice(query.endPos || 0);

        inputor.val(text);
        inputor.caret('pos', startStr.length + this.state.currentConf.flag.length);
        React.findDOMNode(this.refs.inputor).focus();
    },

    onItemHovered: function (index, event) {
        this.setState({selectedOpt: index});
    },

    handleKeyUp: function (event) {
        this.handleMention(event);
    },

    handleClick: function (event) {
        this.handleMention(event);
    },

    handleFocus: function (event) {
        this.handleMention(event);
    },

    onContentChange: function() {
        var inputor = $(React.findDOMNode(this.refs.inputor));
        this.getValueLink(this.props).requestChange(inputor.val());
    },

    render: function () {
        return (
            <div className="mentionableTextarea">
                <textarea
                    placeholder={this.props.placeholder}
                    onKeyUp={this.handleKeyUp}
                    onClick={this.handleClick}
                    onFocus={this.handleFocus}
                    onChange={this.onContentChange}
                    onKeyDown={this.handleKeyDown}
                    ref="inputor">
                </textarea>
                <OptionsBox conf={this.state} query={this.state.query.text} searchField={this.state.searchField}
                    onItemClicked={this.handleItemClick}
                    onItemHovered={this.onItemHovered} />
            </div>
        );
    }
});
