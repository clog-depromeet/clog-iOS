.PHONY: generate

module:
	@echo "✨ 서비스 선택:"
	@ls ./Projects | grep "Service" | nl -w2 -s'. '
	@read -p "📝 옵션 입력 (서비스 모듈의 숫자 선택): " path_option; \
	folder_count=$$(ls ./Projects | grep "Service" | wc -l); \
	if [ "$$path_option" -ge 1 ] && [ "$$path_option" -le "$$folder_count" ]; then \
		selected_service=$$(ls ./Projects | grep "Service" | sed -n "$${path_option}p"); \
		service_name=$$(ls ./Projects | grep "Service" | sed -n "$${path_option}p" | sed 's/Service//' | tr '[:upper:]' '[:lower:]'); \
		echo "✅ 선택된 서비스: $$selected_service"; \
	else \
		echo "❌ 잘못된 입력입니다."; \
		exit 1; \
	fi; \
	echo "\n"; \
	echo "✨ 모듈 선택:"; \
	echo "[1]  Micro Feature 모듈 생성"; \
	echo "[2]  Domain 모듈 생성"; \
	read -p "📝 옵션 입력 (1, 2): " path_option; \
	case $$path_option in \
	1) \
		destination="Projects/$$selected_service/Features"; \
		folderName="feature";; \
	2) \
		destination="Projects/$$selected_service/Domains"; \
		folderName="domain";; \
	*) \
		echo "❌ 잘못된 옵션 입력입니다. 1, 2 중에서 선택하세요."; \
		exit 1;; \
	esac; \
	\
	echo "\n"; \
	echo "🌟 모듈 이름 입력 규칙:"; \
	echo "1️⃣  'Feature', 'Domain'는 자동으로 붙습니다! 입력하지 마세요."; \
	echo "-----------------------------------------------"; \
	\
	read -p "🚀 모듈 이름을 입력하세요: " name; \
	\
	if [ -z "$$name" ]; then \
		echo "❌ 모듈 이름을 입력해야 합니다!"; \
		exit 1; \
	fi; \
	if [ "$$folderName" = "domain" ]; then \
		sh ./Script/addNewDomain.sh "$$name" "$$selected_service"; \
	elif [ "$$folderName" = "feature" ]; then \
		sh ./Script/addNewFeature.sh "$$name" "$$selected_service"; \
	else \
		echo "🚨 Error: Unknown folderName '$$folderName'"; \
		exit 1; \
	fi; \
	echo "\n"; \
	echo "🔨 모듈 생성중입니다"; \
	tuist scaffold "$$folderName" --name "$$name" --service "$$service_name" --path "$$destination"

install:
	@make close_xcode
	@echo "\033[34m[1/4] Running 'tuist clean'...\033[39m"
	@make clean
	@echo "\033[34m[2/4] Running 'tuist install'...\033[39m"
	@make fetch
	@echo "\033[34m[3/4] Running 'tuist generate'...\033[39m"
	@make generate
	@echo "\033[34m[4/4] Running 'tuist graph'...\033[39m"
	@make open_xcode
	@echo "\033[32mCompleted!\033[39m"

clean:
	@tuist clean

edit:
	@tuist edit

fetch:
	@tuist install

depency_graph:
	@tuist graph

generate:
	@tuist generate --no-open
	
open_xcode:
	@open Cllog.xcworkspace
	
close_xcode:
	-@pkill -x Xcode
