import React, { Component } from 'react';
import './App.css';
import FileUpload from './Components/FileUpload';
import MasterPage from './Components/MasterPage';
import MidSection from './Components/MidSection';
import Resultpage from './Components/ResultPage'
import Loader from './Components/Loader';
import axios from 'axios';
import MainComponent from './Components/MainComponent';
require('dotenv').config()

const endpoint = process.env.REACT_APP_API_HOST
var answer = "abc";

class App extends Component {
  constructor() {
    super()
    this.state = {
      selectedFile: null,
      loaded: 0,
      respond: false,
      selectedFileName: '',
      loading: true,
      reqLoading: false,
      resData: null
    }
  }
  componentWillMount() {
    setTimeout(() => {
      this.setState({loading:false})
    }, 3000)
  }
  handleselectedFile = event => {
    this.setState({
      selectedFileName: event.target.files[0].name,
      selectedFile: event.target.files[0],
      loaded: 0,
    })
  }

  handleUpload = () => {
    this.setState({
      respond: false
    });
    const data = new FormData()
    data.append('file', this.state.selectedFile, this.state.selectedFile.name)
    console.log("DAta", this.state.selectedFile);
    this.setState({
      reqLoading: true
    });

    axios
      .post(endpoint+'/predict', data, {
        onUploadProgress: ProgressEvent => {
          this.setState({
           loaded: (ProgressEvent.loaded / ProgressEvent.total) * 100,
          })
        },
      })
      .then((res) => {
        answer = res;
        this.setState({
          respond: true,
          reqLoading: false,
          resData: res.data
        });
        console.log("answer",answer);
        console.log("answer",answer);
      });
  }
  render(){
    const { loading } = this.state;
    return (
      <>
      {loading ? <Loader /> :
        <MainComponent>
          <FileUpload upload={this.handleUpload} load={this.handleselectedFile} name={this.state.selectedFileName}>
            {!this.state.resData?null:<Resultpage data={this.state.resData} name={this.state.selectedFileName}/>}
          </FileUpload>
        </MainComponent>}
    </>
    )
  }

  // render() {
  //   console.log(",,,,,,,,,,,,,",answer);
  //   const { loading } = this.state;
  //   return (
  //     <React.Fragment>
  //     {loading ? <Loader /> :
  //       <div className="App">
  //         <MasterPage>
  //
  //         </MasterPage>
  //         <MidSection  upload={this.handleUpload} load={this.handleselectedFile}>
  //         <FileUpload upload={this.handleUpload} name={this.state.selectedFileName} load={this.handleselectedFile}/>
  //         </MidSection>
  //         </div>
  //       }
  //     </React.Fragment>
  //   );
  // }
}

export default App;
