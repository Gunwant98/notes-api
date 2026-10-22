pipeline{
	agent any
	
	stages{
		stage('Install Dependencies'){
			steps{
				sh 'python3 -m venv .venv'
				sh '. .venv/bin/activate && python -m pip install -r requirement.txt'
			}
		}
		
		stage('Test'){
			steps{
				sh '. .venv/bin/activate && python -m unittest discover -s tests -v'
			}
		}
	}
}