pipeline{
	agent {
		docker {
			image 'python:3.12-slim'
		}
	}
	
	stages{
		stage('Install Dependencies'){
			steps{
				sh 'python3 -m venv .venv'
				sh '. .venv/bin/activate && python -m pip install -r requirements.txt'
			}
		}
		
		stage('Test'){
			steps{
				sh '. .venv/bin/activate && python -m unittest discover -s tests -v'
			}
		}
	}
}