pipeline{
	agent none
	
	stages{
		stage('Test'){
			agent {
				docker {
					image 'python:3.12-slim'
				}
			}
			
			steps{
				sh 'python -m venv .venv'
				sh '. .venv/bin/activate && python -m pip install -r requirements.txt'
				sh '. .venv/bin/activate && python -m unittest discover -s tests -v'
			}
			
		}
		stage('Build docker image') {
			agent any
			
			steps {
				script{
					docker.build("notes-api:${env.BUILD_NUMBER}")
				}
			}
		}
	}
}