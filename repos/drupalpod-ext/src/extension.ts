import * as vscode from 'vscode';

export function activate(context: vscode.ExtensionContext) {
	context.subscriptions.push(
		vscode.commands.registerCommand('drupalpod-ext.start', () => {
			const panel = vscode.window.createWebviewPanel(
				'drupalpod-ext',
				'Drupal Contributions',
				vscode.ViewColumn.One,
				{}
			);
		})
	);
}

// this method is called when your extension is deactivated
export function deactivate() {}
